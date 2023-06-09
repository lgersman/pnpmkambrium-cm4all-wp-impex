import test from './tape-configuration.js';
import Transformer from '../src/impex-content-transform.js';

import { addFilter } from '@wordpress/hooks';

test("ImpexTransformer: ensure setup(...) will provide a clean reset'ed block.settings.transforms", (t) => {
  Transformer.setup({
    verbose: false,
    onRegisterCoreBlocks() {
      addFilter('blocks.registerBlockType', 'prepend-custom-image-transform', (blockType) => {
        if (blockType.name === 'core/image') {
          const from = blockType.transforms.from[0];

          blockType.transforms.from.unshift({
            ...from,
            transform(node) {
              const block = from.transform(node);

              block.attributes.caption = 'our-customized-caption';
              return block;
            },
          });
        }
        return blockType;
      });
    },
  });

  const HTML = `<!DOCTYPE html>
  <body>
    <img src="./greysen-johnson-unsplash.jpg">
  </body>
  </html>`;

  let transformed = Transformer.transform(HTML);
  t.ok(transformed.includes('<figcaption>our-customized-caption</figcaption>'));

  Transformer.setup({
    verbose: false,
  });

  transformed = Transformer.transform(HTML);
  t.notOk(transformed.includes('<figcaption>our-customized-caption</figcaption>'));

  t.end();
});
